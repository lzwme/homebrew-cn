class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.100.4.tar.gz"
  sha256 "4291bb8b5560be397681bfce8869a0c70c727fc317a8e0a34ce4f1b1465592a8"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed2b846823eb8e638095b24356a957a9f9e605f580ed8ca91c3ddf5bda96f4a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0de82840118d598b1c16cfb10870460d14fa4693759545cb6931b4d6935b55df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7e3e1ab6e8f692a311626ef2dfe128e19fa7708130cfe0029dc75acecdaeede"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5801a6f6ec9e5b246471408659a060151e57364f45e4f318c8b2945d197c3d7"
    sha256 cellar: :any_skip_relocation, ventura:       "754a068f0e1124ef6e36b9000b74aa1a4137c892ff42993451cbb349ab3b0453"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a7ce48111d0f22616bc1cd290cdb1575ef2eb2d715602858f1d2292f79de835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c9a5b6e9f4e48e005c3ecc2e9559a2e684e5a2c4dd8f6d302dd4745ebe5d2b3"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end