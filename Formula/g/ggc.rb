class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://ghfast.top/https://github.com/bmf-san/ggc/archive/refs/tags/v8.6.2.tar.gz"
  sha256 "71b5dd209ce945bbff2e9a221023f52b8de9190add9915c1be34626b53c360d0"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83f8e292879b3bc77f20031249d63b6134635c5b07e3bfb3be8bdb055397582a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83f8e292879b3bc77f20031249d63b6134635c5b07e3bfb3be8bdb055397582a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83f8e292879b3bc77f20031249d63b6134635c5b07e3bfb3be8bdb055397582a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f91ad8dc7901a01f786c3008f8f3acc46b29c3738c0058c22b999fb48f8f7e01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb86d08eedd9c1c7fad2b99058531dbd41392ca53a41c7630bc98b13c80cd0f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "558e44bc1a9e1fe39e83fe8b070336810cb182af4a8dbe729ee09364e3ab9c51"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end