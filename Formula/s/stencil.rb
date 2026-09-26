class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://git.rgst.io/rgst-io/stencil/archive/v3.0.1.tar.gz"
  sha256 "3784cbaccf720ea56218732cd411e169dfc1525651598c83e33aec0d782b1b6d"
  license "Apache-2.0"
  head "https://git.rgst.io/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "829fe5920d0f72aa8ac34f97a123222ee278cd31c36192f52a16ca7ccc0bae80"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6981ce4124a4dfd8888f5c43c0e92023fd251bec5876d398e8ebf9aa2f0d947c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e90a10d259105547444c116ded687c13d8b4512c999e25ea7b08357a4ddd1ff6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "36408018363a709bdc4f01ca65b8440db8deca3b419685fcd89c07702b50f0b6"
    sha256 cellar: :any,                 x86_64_linux:      "4efcd77174e8d78cf7398012e09b7b9b0e93c112a28365fa30ad7da02c900fec"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X go.rgst.io/stencil/v3/internal/version.version=#{version}
      -X go.rgst.io/stencil/v3/internal/version.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/stencil"
    generate_completions_from_executable(bin/"stencil", "completion",
                                          shell_parameter_format: "",
                                          shells:                 [:bash, :zsh, :fish, :pwsh])
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_path_exists testpath/"stencil.lock"
  end
end