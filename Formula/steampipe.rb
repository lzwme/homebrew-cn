class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://ghproxy.com/https://github.com/turbot/steampipe/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "bf6e76fcbd1c26e0c47bf7ef212932ab39ea883a8eed30620289b5a0f7ded543"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e5cd745ff8fd4fa654b843d4f80e9c360d28cce6c86d835c5eab67bbc1a92ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9af1eab3c37464e50f1098da755fdc50b8af5b3d1df1c22961567556807b05c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac1acea4102b6cae4c5a98e3c74fbd1c8b33d60aa6fe8086738c387c930038a8"
    sha256 cellar: :any_skip_relocation, ventura:        "06f192e4c519df5ca84ff5e427c0299ee58eab9aa8471eb91a7a0aba89dd6f5f"
    sha256 cellar: :any_skip_relocation, monterey:       "572e772efb46b0948e498d14c1ed88efbcd959a08072137451830d828cc5c847"
    sha256 cellar: :any_skip_relocation, big_sur:        "7037f26226306ec56d546a0c6799f65b1e7f78da032b0cc2322a6fdf9f41907a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39ea0e980ed64dbc43bd139bb6a4984765a2088cc40aaa79d522a0bd6fce4069"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    output = shell_output(bin/"steampipe service status 2>&1")
    if OS.mac?
      assert_match "Error: could not create installation directory", output
    else # Linux
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end