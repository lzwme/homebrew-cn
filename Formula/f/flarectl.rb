class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https:github.comcloudflarecloudflare-gotreemastercmdflarectl"
  url "https:github.comcloudflarecloudflare-goarchiverefstagsv0.109.0.tar.gz"
  sha256 "16c067bbb593336fbbd8933c27c9717ecd849622667b134b78dc6aaeaeb1cfca"
  license "BSD-3-Clause"
  head "https:github.comcloudflarecloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(^v?(0(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34521547815b2e0e0a95194be2dea543ac981beb30b3adb00652fbb7d6c3407d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34521547815b2e0e0a95194be2dea543ac981beb30b3adb00652fbb7d6c3407d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34521547815b2e0e0a95194be2dea543ac981beb30b3adb00652fbb7d6c3407d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7571c9d1fb33369b125ad1d9c205e6ff5f3db1936d31c53f6f202ba1c79d2c28"
    sha256 cellar: :any_skip_relocation, ventura:       "7571c9d1fb33369b125ad1d9c205e6ff5f3db1936d31c53f6f202ba1c79d2c28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fb8c6f187365c74e95f763b0532ef8491406024c533cfba57285da76b9e9065"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdflarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}flarectl u i", 1)
  end
end