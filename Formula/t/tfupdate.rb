class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https:github.comminamijoyotfupdate"
  url "https:github.comminamijoyotfupdatearchiverefstagsv0.8.4.tar.gz"
  sha256 "90d066be2f59df77b00680d98e086174b69bc90fc976b42212c16c58bef5ca26"
  license "MIT"
  head "https:github.comminamijoyotfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23534ab4dd0d87b919a4cd327bc94f58027269bd3c357c9b77f77a135185d90a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5978ed2ef4b15476ddaf2d6856488ddabbf04aab3abe793f6f6b6e4dd4a099b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f10a2083bfac1506c022b56bcd4aaef7d6cc34f7a433918cd0708a77e96cd6c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b68b21a507bc390a0f3bcd1b274d6f272331248dfca0d45770aea86b2d6d8ce"
    sha256 cellar: :any_skip_relocation, ventura:        "86e76b79dbd9d0622b074440093cb61a5a48b0665e31001add16160a1df103eb"
    sha256 cellar: :any_skip_relocation, monterey:       "43d4eb392d86423286a548ea75d1348c3c1f246396e3570bd41bad0bcfb12bbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0c746379af9b988c582ec03ffc26d03548b27c7517df435c8e59afb59703cbf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"provider.tf").write <<~EOS
      provider "aws" {
        version = "2.39.0"
      }
    EOS

    system bin"tfupdate", "provider", "aws", "-v", "2.40.0", testpath"provider.tf"
    assert_match "2.40.0", File.read(testpath"provider.tf")

    assert_match version.to_s, shell_output(bin"tfupdate --version")
  end
end