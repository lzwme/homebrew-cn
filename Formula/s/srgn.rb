class Srgn < Formula
  desc "Code surgeon for precise text and code transplantation"
  homepage "https:github.comalexpovelsrgn"
  url "https:github.comalexpovelsrgnarchiverefstagssrgn-v0.13.4.tar.gz"
  sha256 "778766769b9c7845b6f24cb25c940f675c8634b3ba58bf1c552c717a12fe0ead"
  license "MIT"
  head "https:github.comalexpovelsrgn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c964dda4b9a115fcd5364b25231dffff4f44cd385e847b812265fcce86848cd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d712bc81f1e34eca3ae1162344648b74c436725cb1391ba2939256a80ebe939a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "767b0506c2c603913661c91d19a01e7d4ef04cd04c4df0151fa088a4cd4bb8c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "99466f48efcfdcb949dba856d34750f47a8c7f5f130b1a502211971f70c46fe6"
    sha256 cellar: :any_skip_relocation, ventura:       "d7dfcfbf8108f83cf6786d2db1d3a8064ff8e1d0351da81e0c5f23df7bb7e07e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4283e4beb5740f05691a8df912520d3b27ddd817d3206bce9019afda950b235c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "H____", pipe_output("#{bin}srgn '[a-z]' '_'", "Hello")

    test_string = "Hide ghp_th15 and ghp_th4t"
    assert_match "Hide * and *", pipe_output("#{bin}srgn '(ghp_[[:alnum:]]+)' '*'", test_string)

    assert_match version.to_s, shell_output("#{bin}srgn --version")
  end
end