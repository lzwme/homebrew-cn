class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://ghfast.top/https://github.com/nmstate/nmstate/releases/download/v2.2.54/nmstate-2.2.54.tar.gz"
  sha256 "562517d29e9d6051282e74eb77ca224843268e94b6070dab4d50a957159050c9"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bd77f2897108a26582b434deb8e12baa3acae9383d4786413c11699c5924944"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf50c518ea0663015ec5f2f1b2ffe6b0e84f0e816ad4f9b37ddb3c7be62ac1cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5e6632399240139ee4b77aa37e0bc8a75048f2232aabdc549d5c7cd435352fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfcf4589a0cc908d60f9976fb3a884d586d256014a36f91d6c3277d1207c1da1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccf4931eebe7a2db12177de68b91792a9fc1a19637656bd944bc50be32f0d208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8637d5b378382f64e9d4dc6b2358409779b403c3a9418913b293a5617c13e8f"
  end

  depends_on "rust" => :build

  def install
    cd "rust" do
      args = if OS.mac?
        ["--no-default-features", "--features", "gen_conf"]
      else
        []
      end
      system "cargo", "install", *args, *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end