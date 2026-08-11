class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.39.tar.gz"
  sha256 "509b4e473365c4bd120a2fb4405eabfd43a8398a9ec571c83e00b719db2ac65f"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d885210b0b8d159e578d62935d4f26f976378cdfdfe13f998f26d50c53efb181"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d885210b0b8d159e578d62935d4f26f976378cdfdfe13f998f26d50c53efb181"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d885210b0b8d159e578d62935d4f26f976378cdfdfe13f998f26d50c53efb181"
    sha256 cellar: :any_skip_relocation, sonoma:        "6827faa2d4b5c7ef3638a392653b37c4736d231fc66421d1bcdfc55edd3df70c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fe3096e19bddfde98278fafb03190b9ba8fecea1ff66a2f0aeb9f22a3e6cd33"
    sha256 cellar: :any,                 x86_64_linux:  "e91e1ac9a0d94398b48f034405edba5e01dc80a921e64bf8e39b42dd443a9d5e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end