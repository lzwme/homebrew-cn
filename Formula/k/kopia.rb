class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.21.0",
      revision: "3a38279bcd7ace79369fc657b4b5d968d4b5b2f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70f86ae876f6b301c722a95b72783cc945e1cf7a6438bd6bef64bfbbc92548cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e53312e1ecffec3d49fba4ec78784206cb23f1a0c1ee2c7dc1558bda937c68c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc9ad5f31e9eb9170c07cc7d4b8ec5af6bba15e4d2285f586bdce3f5c514cb3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "19fd5aa8061c7f1ce3d65edf7ee42f3d18d813ba851084e16e074f4de69437bf"
    sha256 cellar: :any_skip_relocation, ventura:       "16f38f884b3b9286c4652eaa63a3e480a247dcf5b8c0ed8a3cb132737faada25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1af2d145b56f26a9141fc220d135d3b211cb9faf857806441d4fe59e2323767"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kopia/kopia/repo.BuildInfo=#{Utils.git_head}
      -X github.com/kopia/kopia/repo.BuildVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kopia", shells:                 [:bash, :zsh],
                                                      shell_parameter_format: "--completion-script-")

    output = Utils.safe_popen_read(bin/"kopia", "--help-man")
    (man1/"kopia.1").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kopia --version")

    mkdir testpath/"repo"
    (testpath/"testdir/testfile").write("This is a test.")

    ENV["KOPIA_PASSWORD"] = "dummy"

    system bin/"kopia", "repository", "create", "filesystem", "--path", testpath/"repo", "--no-persist-credentials"
    assert_path_exists testpath/"repo/kopia.repository.f"
    system bin/"kopia", "snapshot", "create", testpath/"testdir"
    system bin/"kopia", "snapshot", "list"
    system bin/"kopia", "repository", "disconnect"
  end
end