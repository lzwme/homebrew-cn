class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://ghfast.top/https://github.com/kriuchkov/tock/archive/refs/tags/v1.7.7.tar.gz"
  sha256 "8420041802777ae349041b9f0478b774e275028a418226e03d06d0fa17b61d30"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb8b2ca77161b9ce05ce644a16b5c7bb034ba09a35fddde295cd026f8f2f038e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb8b2ca77161b9ce05ce644a16b5c7bb034ba09a35fddde295cd026f8f2f038e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb8b2ca77161b9ce05ce644a16b5c7bb034ba09a35fddde295cd026f8f2f038e"
    sha256 cellar: :any_skip_relocation, sonoma:        "04b33d9ea5f91e6d44507a02ab582b04866036017af5f5918e085e15f18efc7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2d38b4d16053dfcabe8652b412e99c70dc75dc03377b5af0610b2db7b9f557b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "136feace426615874b8c95afc49284eac2834ceec7a9b7caf859e7ff538fa5ee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kriuchkov/tock/internal/adapters/cli.version=#{version}
      -X github.com/kriuchkov/tock/internal/adapters/cli.commit=#{tap.user}
      -X github.com/kriuchkov/tock/internal/adapters/cli.date=#{Date.today}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tock"

    generate_completions_from_executable(bin/"tock", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tock --version")
    assert_match "No currently running activities", shell_output("#{bin}/tock current")
  end
end