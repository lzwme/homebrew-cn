class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https:github.comoctobuildoctobuild"
  url "https:github.comoctobuildoctobuildarchiverefstags1.8.0.tar.gz"
  sha256 "97d1bf564535c8ad503caf1851aff4e232cbaaaee933d373c6c5f88249d55504"
  license "MIT"
  head "https:github.comoctobuildoctobuild.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5310e5c897311a32efd76ca20f2368cccb984671d165e36ec5e560486a35392b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d069f88b2e44059974eec886685c3f7c0bc41ea078ace5d06a8842320f885e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79961f6eccd84162dbeba8bde89dd1f50d68c2131c009181cb94f1c6f7a43329"
    sha256 cellar: :any_skip_relocation, sonoma:        "db49813cedbeec94eef5eb32a772bdc1b3c3966639968326c815be429f72f02f"
    sha256 cellar: :any_skip_relocation, ventura:       "ddc5573014f92718017d1b5a8e48b2065732bc7671d53675142aec60a5e05378"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "669ddce48a0bf416055272ec208403dcad70056ffeae37a1a7d2daf1ea2cec4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd8b61fab648be327bd6ede7d06663e695b2d1e00fb61b2cb4325d3a3fe91d8b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  resource "ipc-rs" do
    on_linux do
      on_arm do
        url "https:github.comoctobuildipc-rsarchivee8d76ee36146d4548d18ba8480bf5b5a2f116eac.tar.gz"
        sha256 "aaa5418086f55df5bea924848671df365e85aa57102abd0751366e1237abcff5"

        # Apply commit from open PR https:github.comoctobuildipc-rspull12
        patch do
          url "https:github.comoctobuildipc-rscommit1eabde12d785ceda197588490abeb15615a00dad.patch?full_index=1"
          sha256 "521d8161be9695480f5b578034166c8e7e15b078733d3571cd5db2a00951cdd8"
        end
      end
    end
  end

  def install
    if OS.linux? && Hardware::CPU.arm?
      (buildpath"ipc-rs").install resource("ipc-rs")
      (buildpath"Cargo.toml").append_lines <<~TOML
        [patch."https:github.comoctobuildipc-rs"]
        ipc = { path = ".ipc-rs" }
      TOML
    end
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end