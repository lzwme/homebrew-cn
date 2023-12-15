class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://ghproxy.com/https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.3.6.tar.gz"
  sha256 "453d164c16278de693bb72199634b02e3a6a4a4cb3ce07a57a5f18dda2c5b6ac"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23ac1952b53343bb71c77e98659dba27161688b7558fdd3b0d74bec886debd02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb9dc416fe539782b57109e8f7603e8be44c2e908a22099e4752abb19a2a8de9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "686681cf4ca0d6397401e44b8406e421ed07f1b2f693ff8b0f15f51448d2c2e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "582ffd06bea0e81a850e2e2c2240598b4f0ed165f28ce817f948726da56ea1b1"
    sha256 cellar: :any_skip_relocation, ventura:        "7619cd86af22b74074c0bb7b3889b72a530ceaab83e9cb8b32308dd6c3467015"
    sha256 cellar: :any_skip_relocation, monterey:       "44b2f704e512addacac4bd1134133d03d14802223d70ec4c6e6404507247442c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e033db09a5db06359b017ebe9d1b3104d8b73007714f1e52da6812193c67515"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    output = shell_output("#{bin}/kubefirst version")
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      version.to_s
    end
    assert_match expected, output
  end
end