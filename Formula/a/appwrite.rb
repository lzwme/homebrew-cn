class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://ghfast.top/https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.2.0.tar.gz"
  sha256 "a8dfde98c287166a076b1b11492a63dbc710262dedc286474667a3e76c6159b7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ef62c9fe801b8264126a672efc0a10ec58c982b92778d3fc1d27f65eb8409062"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ef62c9fe801b8264126a672efc0a10ec58c982b92778d3fc1d27f65eb8409062"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ef62c9fe801b8264126a672efc0a10ec58c982b92778d3fc1d27f65eb8409062"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "600c2e5933a949921b3debae050c10e0464c75a0df1803d93c4cfcd79b8fae78"
    sha256 cellar: :any,                 x86_64_linux:      "87aafe44a8bfeab3c8885f8f2de1583c4acfbff77bd41675246ba824b0704533"
  end

  depends_on "go" => :build

  def install
    # https://github.com/appwrite/sdk-for-cli/blob/4399a3321898f40cf982acbd4859d506c9d4d9f4/.goreleaser.yaml#L19-L22
    system "go", "mod", "tidy"
    system "go", "build", *std_go_args(ldflags: "-X github.com/appwrite/sdk-for-cli/internal/app.Version=#{version}")

    generate_completions_from_executable(bin/"appwrite", "completion")
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end