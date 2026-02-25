class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://ghfast.top/https://github.com/steveyegge/gastown/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "821026116293fdf27ec33c89995672ba3473115d3111773d6be780f49e42b5a2"
  license "MIT"
  head "https://github.com/steveyegge/gastown.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "44d7086735b1b1ea600e897eef3a86f04a5fd800fb4e7073a98e72a3a09c5da8"
    sha256 cellar: :any,                 arm64_sequoia: "b3bcf415c80a39d14c53233f5d431c7c90522df8117e1025b6983adc1200d5d8"
    sha256 cellar: :any,                 arm64_sonoma:  "517391d9603643d2fb0529d28e8db532ef5e62a9f64bd457de200830c3a0dc50"
    sha256 cellar: :any,                 sonoma:        "e3968e7a408d03b7d45a1cd191e287529b0cbdadd7329e73641d0789aae6d082"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0c258e7e10ca2de04751a5cb3dfb97e89c0d15846d06b3b9d1bfc4130e45b4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14cf5cafe62fb192425d52fb0635b0f803df16d62d8ef747fff715d9f55f1b13"
  end

  depends_on "go" => :build
  depends_on "beads"
  depends_on "icu4c@78"

  conflicts_with "genometools", "libslax", because: "both install `gt` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/steveyegge/gastown/internal/cmd.Version=#{version}
      -X github.com/steveyegge/gastown/internal/cmd.Build=#{tap.user}
      -X github.com/steveyegge/gastown/internal/cmd.Commit=#{tap.user}
      -X github.com/steveyegge/gastown/internal/cmd.Branch=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/gt"
    bin.install_symlink "gastown" => "gt"

    generate_completions_from_executable(bin/"gt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gt version")

    system bin/"gt", "install"
    assert_path_exists testpath/"mayor"
  end
end