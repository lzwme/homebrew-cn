class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.io"
  url "https:github.comkubefirstkubefirstarchiverefstagsv2.4.6.tar.gz"
  sha256 "d331afffdfef3ad5a9c56e2eaa3a813fa543525c1d000a28e7c9694f047fff73"
  license "MIT"
  head "https:github.comkubefirstkubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "893030eb2f655ac8ac923ecf27025e73fbf0383a4576d02a371d811851d549a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d40f1ae441c85866fce39eca6ad749187338a02ad4c1d2d02b63592cb4db366f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75f1b41efc148e58f3d0437af73abb190703d5226cd326aed722cc1b634a6e85"
    sha256 cellar: :any_skip_relocation, sonoma:         "307066a1fbc4aff36e7bf1062cb9200e04ae7ff6d9412690889ea78ed09bc3c5"
    sha256 cellar: :any_skip_relocation, ventura:        "d8cb11de6f368c0e40163d11ac31f06415a5463b7b95ddd489cd634c9f7d7122"
    sha256 cellar: :any_skip_relocation, monterey:       "ec6e22d8cc609d3d4b7bc01095616312224982f4d426aa04081cea0a09a37e2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2722e4f2a3618e71cd1b0191bb7f21040192534d1793349a765869cd69318ac"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comkubefirstruntimeconfigs.K1Version=v#{version}"
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