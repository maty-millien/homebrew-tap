class Ggx < Formula
  desc "A fast AI-powered git workflow CLI"
  homepage "https://github.com/maty-millien/ggx"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maty-millien/ggx/releases/download/v0.4.0/ggx-aarch64-apple-darwin.tar.xz"
      sha256 "106c14222f442479a96e52c936a0e365bff34e6c7e006e50a92b84032bd948a9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maty-millien/ggx/releases/download/v0.4.0/ggx-x86_64-apple-darwin.tar.xz"
      sha256 "6d6335ac5a3849b44cc2ef8e8f68c7e9baab724e9cd9c8b0e67fb29b18bb3e98"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/maty-millien/ggx/releases/download/v0.4.0/ggx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1d95f90e4f0e113f06c24ca7d8891ecba2e21bdec29a03122ee327667d76e2bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maty-millien/ggx/releases/download/v0.4.0/ggx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "695f8f060b02401fff883268ac05a46988360335b69b3aeb558c61c0744707bd"
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
