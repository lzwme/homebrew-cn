class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https:github.comvmwaregovmomitreemaingovc"
  url "https:github.comvmwaregovmomiarchiverefstagsv0.48.1.tar.gz"
  sha256 "ca6975ce24cc96700d4b16a1793d4fd1c6b14a42031e4a847be6bd09d6fe522a"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc8eb283a38928ba5beb9018f5af5161b2eba1b2c7db4f4722071fe3b638d1e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc8eb283a38928ba5beb9018f5af5161b2eba1b2c7db4f4722071fe3b638d1e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc8eb283a38928ba5beb9018f5af5161b2eba1b2c7db4f4722071fe3b638d1e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5399b1ade12e8d1cecb326c9e6630117d5fe84ef08dd48397a59929740f7abb9"
    sha256 cellar: :any_skip_relocation, ventura:       "5399b1ade12e8d1cecb326c9e6630117d5fe84ef08dd48397a59929740f7abb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceb28bdd7cfa5279d1dd0057b7e412e4ee3c225a755c33c72f5332f30be3ea5f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comvmwaregovmomicliflags.BuildVersion=#{version}
      -X github.comvmwaregovmomicliflags.BuildCommit=#{tap.user}
      -X github.comvmwaregovmomicliflags.BuildDate=#{time.iso8601}
    ]
    cd "govc" do
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}govc version")
    assert_match "GOVC_URL=foo", shell_output("#{bin}govc env -u=foo")
  end
end