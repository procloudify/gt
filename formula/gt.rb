class Gt < Formula
  desc "Simple git flow CLI — push, branch, pull, merge in one command"
  homepage "https://github.com/procloudify/gt"
  url "https://github.com/procloudify/gt/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "REPLACE_WITH_SHA256_AFTER_RELEASE"
  license "MIT"

  def install
    bin.install "bin/gt"
  end

  test do
    system "#{bin}/gt", "--help"
  end
end
