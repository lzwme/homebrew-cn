class Dbxcli < Formula
  desc "Command-line tool for Dropbox users and team admins"
  homepage "https://github.com/dropbox/dbxcli"
  url "https://ghfast.top/https://github.com/dropbox/dbxcli/archive/refs/tags/v3.3.3.tar.gz"
  sha256 "be0187b703ef726b21ace33212a9b9f743502e74a8149d2f356fda650408c1a7"
  license "Apache-2.0"
  head "https://github.com/dropbox/dbxcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d12c0f05d7f1599e85b676f3e0820917c5a8e01e47cf3677c5432a253db6c1e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d12c0f05d7f1599e85b676f3e0820917c5a8e01e47cf3677c5432a253db6c1e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d12c0f05d7f1599e85b676f3e0820917c5a8e01e47cf3677c5432a253db6c1e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "34366404c801933b7d256ac160f3260e955427c1f8199a7c0bfd579d6fa5cdad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7544a3c7f7f35e8e8fe9b483579d9d60c0f2819af141466f80243a229f24f148"
    sha256 cellar: :any,                 x86_64_linux:  "1d7c912d0624943941633b6bfad04b2f1f9d28abe1ddc466129421f7e0a0df94"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dbxcli", "completion")
  end

  test do
    ENV["DBXCLI_AUTH_FILE"] = testpath/"missing-auth.json"
    output = shell_output("#{bin}/dbxcli ls 2>&1", 1)
    assert_match "no saved Dropbox credentials", output
  end
end