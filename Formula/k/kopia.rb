class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.22.1",
      revision: "4526f031bf196c91cd874f5b5cf658ed434e7279"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08722c1ec7a73725932bdecff9e62900369a7846478cecd685f508e7bbee9e6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4e83ea26fe2a40206cfb00acd6d7af93ba818e3a97f6f0a0766433e596ef84e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c021d9b5f12ff596f7981427e339c3f39787281e1b9ed5aab8924ee37f3a8a68"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6b0649dff7565c5cc5952382b24e8b6906974ed4905d35fd09139140f00a92a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca76e38e813c12effeac88327dc359319d51ba88d5d388f5db662419a3dd5e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c61e5631d1d1ae01af7fab04ca4420a7586e66581d72ce5991e1da70a1bc8f5"
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