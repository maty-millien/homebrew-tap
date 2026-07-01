class Ggx < Formula
  desc "A fast AI-powered git workflow CLI"
  homepage "https://github.com/maty-millien/ggx"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maty-millien/ggx/releases/download/v0.1.0/ggx-aarch64-apple-darwin.tar.xz"
      sha256 "4a869c82a87df01f8e1302ae6b19920b79e9b75ebe28b6ce802df27255bd827f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maty-millien/ggx/releases/download/v0.1.0/ggx-x86_64-apple-darwin.tar.xz"
      sha256 "022c81fbbe6ec5b731dd5bd408a0b28b7753170fffd19e5da84c910d9e7fde80"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/maty-millien/ggx/releases/download/v0.1.0/ggx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7c1bce44cf366b9fe70abedb30dd33d2878db7c6e54bdf82ccba2c19040d560f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maty-millien/ggx/releases/download/v0.1.0/ggx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "729bcc95060458e14354df5083dc158ced639f6a509c633392d87f14501f7790"
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
