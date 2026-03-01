class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.61.0.tar.gz"
  sha256 "9c85502cbb28b3812aeec921fb8fe51694d5a837aa4415c026c327522492ba05"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df53ef9c503ff362b21181ed621beccb9bd2df86898d19433718871a5a4dfba9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2458f572c4f5e5b2578b68bdec8e1d20a8927b08c4033188483561135bc88217"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b06d83e48173d0fe8c24f14556a6a9482ff6fc1d08ebdffd98709a23049eca60"
    sha256 cellar: :any_skip_relocation, sonoma:        "68c892ea55fd7e5d7700bb9b99afbd3ce4c766ab67cd0ed1b230d26181c83fcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f96dfd761c00cd387878eb57583c71acaddcf16754c96c9829a05c21580f6dc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28567c81505ef014cf2cb05270f398ef8e03219e9aa596ed685abd8cfcce0b9f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end