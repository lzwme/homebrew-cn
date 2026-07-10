class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/pitchfork/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "6a65a644c8e3ad416296b4cfc2ea77b793e95ac64ee7c682c947e3cc283056f8"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a43dd6672241fc3f8e2ea868de1819cd7cf184612b1da1dfa4c2c0ec0b05ea8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f63074d87e765832565a2c60490ec4d12d19174bf08ae04b909ce308b9b2897"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bb15458c17418ccaa5ccb9cd64d7fbbabe27ea8c587695c3943cc35fb3288ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "c61760f51c6f2793b2a3d76f40597f67a0151a94fe57d06ce2406b4d536e1f5a"
    sha256 cellar: :any,                 arm64_linux:   "714ba4eca60d264a05514f6cce60cb2e7420e773bb87bcf517a994cbfb27f11c"
    sha256 cellar: :any,                 x86_64_linux:  "8c16d4351589cea0112eb5c0608f0abd8b45988bf49945ddaf5e1fe73cf07680"
  end

  depends_on "rust" => :build
  depends_on "usage"

  def install
    (buildpath/"ui/dist").mkpath

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"pitchfork", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitchfork --version")

    system bin/"pitchfork", "daemons", "add", "brewtest", "--run", "echo brewed", "--ready-output", "brewed"
    config = (testpath/"pitchfork.toml").read
    assert_match 'run = "echo brewed"', config
    assert_match 'ready_output = "brewed"', config
  end
end