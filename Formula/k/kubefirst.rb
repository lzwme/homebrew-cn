class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.io"
  url "https:github.comkubefirstkubefirstarchiverefstagsv2.4.15.tar.gz"
  sha256 "449145db5f9a2312113fd0a063d2ddc653c6387f730196892cdcc2b05aaecd7c"
  license "MIT"
  head "https:github.comkubefirstkubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42fc8ce709d88cac362ffdc09fba831bcc1dade515e378f8c255c6cd860b5f1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5698013feb5c6e2d997c519a4fa4b316b7e37833fd12a8d55d4401d0037ccc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68572b7c732de7af22fcae6ccb5ad4ce271732fd359011bd3bddfb36d30c9082"
    sha256 cellar: :any_skip_relocation, sonoma:         "b42c83e4df3e2297541b96cfcbef7988b12061fb5ac6e744dff7ae05de1f18f2"
    sha256 cellar: :any_skip_relocation, ventura:        "e2d65062987cd68d5841ec15b14cd9a4d1c68d0b9b219977acf052b21cb35889"
    sha256 cellar: :any_skip_relocation, monterey:       "162b02362f2c7a075327ab47246c6f06bcda6a3f0e47950821cc6c6d6b4fd37f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1f2ccc0ddb2968e890fc457f7089b0321187fd24b93ac99eb00aefcf6fcc63c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comkubefirstkubefirst-apiconfigs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin"kubefirst", "info"
    assert_match "k1-paths:", (testpath".kubefirst").read
    assert_predicate testpath".k1logs", :exist?

    output = shell_output("#{bin}kubefirst version")
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      version.to_s
    end
    assert_match expected, output
  end
end