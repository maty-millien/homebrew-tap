class Ggx < Formula
  desc "A fast AI-powered git workflow CLI"
  homepage "https://github.com/maty-millien/ggx"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maty-millien/ggx/releases/download/v0.5.0/ggx-aarch64-apple-darwin.tar.xz"
      sha256 "68c28edfbb59d45a99bc66f797e2db898d40aae2c8543c99057cc3a2b86db518"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maty-millien/ggx/releases/download/v0.5.0/ggx-x86_64-apple-darwin.tar.xz"
      sha256 "471f37fc8198300ae96ece8f6469cf3fa0df96bbd2675500dc489afb851c15b6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/maty-millien/ggx/releases/download/v0.5.0/ggx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1b6ae670693b4a083f37edcb97d34830071308716484ce3c49abfd2c8ed8bf3d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maty-millien/ggx/releases/download/v0.5.0/ggx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6cf31cb648da563b017d6032e642b7050a91efb3069eca7749682d885e30e2b4"
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
