class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.konstruct.iodocs"
  url "https:github.comkonstructiokubefirstarchiverefstagsv2.7.7.tar.gz"
  sha256 "c574012f9d2050d09b060618ec45077c503b5646a7dc81581980c0bba89e7887"
  license "MIT"
  head "https:github.comkonstructiokubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d26a520b09bf5b2a275d079be8fb9f0f776e48805c26202039a7320cadee4e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70197e8744370b0363c7204bfae3dffc39bb308f977103e8283479dd1e4d3303"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ee84dee7890c11b4fca5ce5beb8722f6c55121063fb510b570b967fc60e6f06"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ce3cd3b08a8239224ff0a5b6939b00b2a8efea2122d1abff33738fdf6cd8bbb"
    sha256 cellar: :any_skip_relocation, ventura:       "a0485eaea6689736dbeb2bd7126f35c1d9347ab82d81d59615461f4bdb5b8d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "106e35b8dfb0d185ed826ddc828790edc2e022db59afbb8dc78d9f283d7b241b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comkonstructiokubefirst-apiconfigs.K1Version=v#{version}"
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