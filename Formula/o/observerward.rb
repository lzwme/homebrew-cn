class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://blog.kali-team.cn/projects/observer_ward/"
  url "https://ghfast.top/https://github.com/emo-crab/observer_ward/archive/refs/tags/v2025.11.23.tar.gz"
  sha256 "d9db74bd0d07f6300063f5273123aefa7d45abfd3626a36e31e4798d1f51dc07"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e2d01dad1b741d09164bac91213e4886d681e0ac2cd725bce7869b7f0b00f22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e390ea662ee74f580a6f42cc7eccc7dc41baff427ddb1437fa5cca26e9a2eebe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fad5339fcf2e0e254ff232fbd5856c67eee4448ed9049469292551b1dc525229"
    sha256 cellar: :any_skip_relocation, sonoma:        "09d6f689de28ea7d56cf86f5c78173c8d3d60e5753eefca2700db625e4bedbac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbb2af51258bdd081203e6d21e03f0cbcc19270498f17b69c5ac9f757e7af180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab31264b723fa112f4e64af6d7f0e84710edc0cc35caff6d92f1487e221baf21"
  end

  depends_on "rust" => :build

  def install
    rm ".cargo/config.toml" # disable `+crc-static`
    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utils/linkage"

    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end