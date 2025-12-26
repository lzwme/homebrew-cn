class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.52.0.tar.gz"
  sha256 "f0a78ffe3f296b01992fe166b4191eddd7deea2e00b9449f748072391dff48a9"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "639bfbd797aef7ef7be76dd8cec6d749490fbb97e22734802b00501bf82e6f95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52e1bada9a1322c05209d92b720cb6b1e13307e9aa550d29cf5bfbfb622c5c8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3e102635f311e7855be0c346f90cc9757000dc18e90bce7860bef3833c2c6f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5446b5f6295850b96aec27f9f817c6f73a090fba812af07415388b1bfce201bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c0f1d5dc61adbb9b987e64ee11484b44e19893d6854e5258988191f1693c8a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03deb473cb343cfccd3688e726886c719b6df60197919b8ae90984d1640b5882"
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