class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.10.tar.gz"
  sha256 "5be64c481d27b327156230bb6c20d99148f408c3c91d2fc9ac3c89d573d6978d"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9dcda109480fdff78f1b27441aaccf3c3b1de51636b4f550bc2137db95cbec79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97c5a8da39ce788e18a85fae0d7bcead076978338c33ce589f576e761210767a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de485dc0608d1558c595ef2d30a681b21d4ed20d56de6d6b81bf9238d8387d2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc617cfdc3f057574ae64351c96bd57a71bfbe7459762b0a6927a50c9db31d0b"
    sha256 cellar: :any_skip_relocation, ventura:        "66eb366601e217205a21218fb9e26ef632bc645433861cfda939e5e1ba187742"
    sha256 cellar: :any_skip_relocation, monterey:       "1cd843772a8e93f86c3730060a3db96465c84f8e3c2e389e805282d3c4d0140b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eda01531c35c09ae4e85baf8e0aada24fb643d002a7698f7c18f841e3822683"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), ".cmdneosync"
    end

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end