class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://ghfast.top/https://github.com/wakatara/harsh/archive/refs/tags/0.11.12.tar.gz"
  sha256 "89ce9ab204a8ec444e92268f16ecabcfaf5a6ded412d5868e7b75bce091f2eac"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d36a1f26846410136d4e3dc362114d33fd020c75beb65ae752844dd29416b71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d36a1f26846410136d4e3dc362114d33fd020c75beb65ae752844dd29416b71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d36a1f26846410136d4e3dc362114d33fd020c75beb65ae752844dd29416b71"
    sha256 cellar: :any_skip_relocation, sonoma:        "87600cfd1462a12d4028db76d39ac22d2e82071928a166b4aa033e546de3cec4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2780c2db34a2834a2609730a736b256d089eab1b46f7b348ecf71501d2e8f58f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28616bd7a987093e07f5d5cd2bced81b60afcd9378d41ff7429c7573ff3c3a0c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wakatara/harsh/cmd.version=#{version}")
  end

  test do
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
  end
end