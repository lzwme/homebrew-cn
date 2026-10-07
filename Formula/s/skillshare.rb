class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "2cc1da5364bfd0ed948f4a107b92eef98025b96b4720dad12ba36fef8fef1638"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f554b0b8890094069d6f09d1f4b8fa42deefedfacf30ef79f009fa40be52c9f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f554b0b8890094069d6f09d1f4b8fa42deefedfacf30ef79f009fa40be52c9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0f554b0b8890094069d6f09d1f4b8fa42deefedfacf30ef79f009fa40be52c9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fb30c9f1ebf4ce8d567a734ae9798e9ca013c34058e0282cb75555b677b77865"
    sha256 cellar: :any,                 x86_64_linux:      "da32986d89d0197b690522107de45c88e5a993f0254f9295b832b01bedd0bfbb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end