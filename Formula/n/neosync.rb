class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.15.tar.gz"
  sha256 "cd7a757b19edf6227ca5a459322d415b8dee210af90eb4a7a0384aebf7ccf0fe"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7bdddab6a39713cb58d4f54b588f064ae14562c56a2277758f526dd77631f755"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9921cfdd6994e265670b4f4f15159cd5eb5966c1d6aef4b02985a9f42f568777"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "132879baa536bc5fcc4a64e7c5568630deaa5c9ae4831a00e0d3ee7c5c7358a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "16e8b731948686ae3b33bd559c2e0ba8079019a94d36871a009209cc89d471b7"
    sha256 cellar: :any_skip_relocation, ventura:        "4a09898512e9786cf3004d051f42430dd113ed49d0dc8ab7bcff21ec400a9878"
    sha256 cellar: :any_skip_relocation, monterey:       "779928f0925ca3ac1ade1e10892509433daa62d3c549431996626f0794515848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce8e294f45384936f647ca94dbc259ed9a28b6f5122bc5c5d7fbb6a78068542a"
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