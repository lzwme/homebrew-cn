class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://www.mongodb.com/docs/mongocli/current/"
  url "https://ghfast.top/https://github.com/mongodb/mongodb-cli/archive/refs/tags/mongocli/v2.0.9.tar.gz"
  sha256 "5806ac8ba8bfc6e0527a4c8d389195edcf5f40534d485256338dc155520780f9"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bae426beeb93fb836b87c2ff3b9ac2085695866f7458664d794c3bc3b77b13fe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ebfa2a43d685e3c1f5b4f8799def3e77de9033859983548da1d9e74d8278099"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5199542d9cae04f41a081098e09c2e1157ad482cdd74a6a67715915cd1e0f52c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c261e142f5436685521935a7166c0251acce6f9c5eeb50de289ea8527e859b19"
    sha256 cellar: :any,                 x86_64_linux:      "2bf73acd964dcbb9e3fa787a68fa611e78c93720032e68852d0051c26d6b7653"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    with_env(
      MCLI_VERSION: version.to_s,
      MCLI_GIT_SHA: "homebrew-release",
    ) do
      system "make", "build"
    end
    bin.install "bin/mongocli"

    generate_completions_from_executable(bin/"mongocli", shell_parameter_format: :cobra)
  end

  test do
    assert_match "mongocli version: #{version}", shell_output("#{bin}/mongocli --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/mongocli iam projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/mongocli config ls")
  end
end