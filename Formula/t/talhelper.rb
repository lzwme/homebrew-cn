class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://ghfast.top/https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.44.tar.gz"
  sha256 "e0e132bd2491bceb0daa16fd78264f952449a449b0c2b3886615477f8985abe1"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9b0c6b87f50678c196a0ddd61f12bfb1aac04a788d883f21aba3516b19c594c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9b0c6b87f50678c196a0ddd61f12bfb1aac04a788d883f21aba3516b19c594c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9b0c6b87f50678c196a0ddd61f12bfb1aac04a788d883f21aba3516b19c594c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9051ebe23c260408ce2a310cf243f046f4e4cda70de4e7571c44702a3abb0cfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8013b0aead5eca87de1518a814513da65814808cc5f0f743a91674853a36f3c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44e8be7d86f47c8cc33b0ddbffd80a166a2a713937abd5df27b52a048f72225d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", shell_parameter_format: :cobra)
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end