class Caire < Formula
  desc "Content aware image resize tool"
  homepage "https://github.com/esimov/caire"
  url "https://ghproxy.com/https://github.com/esimov/caire/archive/v1.4.6.tar.gz"
  sha256 "91af988656924387c1c2c7ccf0c263c2df2843bbfca58d28c5ea239cee4861af"
  license "MIT"
  head "https://github.com/esimov/caire.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de8d5498c8a7225927089e78b74262da38c07c25676149e254ed2f51dca071b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc8a8ce5ea3d3f5641ea6d92fb82e49c4eba64d6d3396740de5b49afedd666c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55bf8972c5e39debec946d4dc49bb0d100368477fab2ef191faeff14b762420e"
    sha256 cellar: :any_skip_relocation, ventura:        "02e2bb7f928fdf07be538502c77b1f5d23d9e5955479085c69273f8f8522b268"
    sha256 cellar: :any_skip_relocation, monterey:       "c22d0b1082028816b15909d23ed4fe75e15c18adbdcb59031d26670c193b2ab8"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a1114072957e1012c78d2457d5f365cca2ca1c4af69a4ce8d7849dee0753398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c03ecc2961e471b765435ca1ece10bce69f77a592ef683ab75138b52e132f7f"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "vulkan-headers" => :build
    depends_on "libxcursor"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "wayland"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/caire"
  end

  test do
    pid = fork do
      system bin/"caire", "-in", test_fixtures("test.png"), "-out", testpath/"test_out.png",
            "-width=1", "-height=1", "-perc=1"
      assert_predicate testpath/"test_out.png", :exist?
    end

    assert_match version.to_s, shell_output("#{bin}/caire -help 2>&1")
  ensure
    Process.kill("HUP", pid)
  end
end