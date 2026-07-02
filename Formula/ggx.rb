class Ggx < Formula
  desc "A fast AI-powered git workflow CLI"
  homepage "https://github.com/maty-millien/ggx"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maty-millien/ggx/releases/download/v0.3.0/ggx-aarch64-apple-darwin.tar.xz"
      sha256 "b4a26aa1ffbad52f045287b3f2d4b4ea50768d796f0c7d8b8bfd93b94e8c7776"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maty-millien/ggx/releases/download/v0.3.0/ggx-x86_64-apple-darwin.tar.xz"
      sha256 "2d5ce8271a39f3f91256c1cb9bd22e880af14c527a6de7a3ce7b3186eb596f5c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/maty-millien/ggx/releases/download/v0.3.0/ggx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6b75616e8d15493796af5af6cf06ba6a50f28335e34320a2133259126af9609c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maty-millien/ggx/releases/download/v0.3.0/ggx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7bd18e1056224ad60a5e7204076e62b49f67b0aee107520a4b6e8fd4e91120ab"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "ggx" if OS.mac? && Hardware::CPU.arm?
    bin.install "ggx" if OS.mac? && Hardware::CPU.intel?
    bin.install "ggx" if OS.linux? && Hardware::CPU.arm?
    bin.install "ggx" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
