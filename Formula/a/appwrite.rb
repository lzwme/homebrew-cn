class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://ghfast.top/https://github.com/appwrite/sdk-for-cli/archive/refs/tags/27.2.1.tar.gz"
  sha256 "cdaeffa4f5089fefdd0464451279d7991d0d052457d6a96d70a17244dd165fc8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ef802650b2861a3b3e1d91878f686781b797daed2519c3d7db7322d8e5707fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ef802650b2861a3b3e1d91878f686781b797daed2519c3d7db7322d8e5707fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ef802650b2861a3b3e1d91878f686781b797daed2519c3d7db7322d8e5707fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e72e2add3896a67a0d4b450dfae9fedac53d0d57a61ff8a3489e0f11284c11e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "030608a67b103f564f38e2a18ed30617c2573f30c12c668c7eace88f7e39584e"
    sha256 cellar: :any,                 x86_64_linux:  "4bffac1ca9bb47a470213709eb74472e89e2e37335e4db9c95cd8e3058f8d827"
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