class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https:launchdarkly.comdocshomegetting-startedldcli"
  url "https:github.comlaunchdarklyldcliarchiverefstagsv1.15.4.tar.gz"
  sha256 "22f8309b139b03d499e624eadde8dad1dd92992c18886ddebd243dd5ad6ab4a3"
  license "Apache-2.0"
  head "https:github.comlaunchdarklyldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0351985936b82301d9d08222b08ed7baedc58098cfc191c014dc19a6e15e6ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98799713ad34902e0f096c267e0edda51cb5e94046a4a02e80120f366d1e7db9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47748053f181655bb311b9f49ffe0a94e203a21fc2207034debeb625b1b75946"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e95c3a5d56d8d35958f366e15693fa54d115f6ce55672af18d710c9e3f87498"
    sha256 cellar: :any_skip_relocation, ventura:       "75c665d5fe1496407c6377d92bf66f41a19b16eec28b83dfad167d0a46a3aa2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fcf2efff9b51c61cbd9f43cb4731bc4efbf52f52c130d97605dde310be01268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2776c65a1951364719a9644c613ca7e5812633daf1d8bf69756236a462010034"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"ldcli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ldcli --version")

    assert_match "Invalid account ID header",
      shell_output("#{bin}ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1")
  end
end