class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.51.2.tar.gz"
  sha256 "4c8df679613b10364dc6440bb7d63a06c2569d60a224de0e9fa3aeb0ea2b6642"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "527434379db13f001f4b2404914fe4ae3fa1458ba164e99f42ae6fa93f4f644f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58dc632d26b11104bd8b3c3209859420c288680cd79da56e92ae40ae1ec91459"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e3642ae1efe1b86e294e9be03a3bf90180aa708296ca9593c202831b601e4ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c3e49b9b0a1c0b9fe8645aa422e98b62467497c70d9ea668c47d09a5b04783d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "338ab2855a5d9efb62d799e794480c893d8c1c0e78c898d5b69059b2d6f8c73c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2758943f7d8a60d26f15feca991aafd017da91f6e70c22e568412fe336f0b638"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end