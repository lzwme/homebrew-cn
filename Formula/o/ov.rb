class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https:noborus.github.ioov"
  url "https:github.comnoborusovarchiverefstagsv0.39.0.tar.gz"
  sha256 "f0505b6862cf3f7ffb2883b3184bcc15195c6f3df9c50137345715c64d7644d3"
  license "MIT"
  head "https:github.comnoborusov.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "784eff397e175380af35feaa109b1f1565eab5ab931b327007d17db672925b63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "784eff397e175380af35feaa109b1f1565eab5ab931b327007d17db672925b63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "784eff397e175380af35feaa109b1f1565eab5ab931b327007d17db672925b63"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fff1f4c38cf8f81bb787632a5bb4b3844152411f7cef89ac20681c46b955ad6"
    sha256 cellar: :any_skip_relocation, ventura:       "0fff1f4c38cf8f81bb787632a5bb4b3844152411f7cef89ac20681c46b955ad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d1f4053711a121cd5e8225d725a1a0cbe48020323c21398503a819d60db6d1c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ov --version")

    (testpath"test.txt").write("Hello, world!")
    assert_match "Hello, world!", shell_output("#{bin}ov test.txt")
  end
end