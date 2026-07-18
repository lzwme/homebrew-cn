class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.113.1.tar.gz"
  sha256 "db926b099c265c4e081abe39bb6dbe652582d2d4f1559a7b9d09d38dff73529d"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4003f3c771139be79fe931416647b779fcce2f5bbdcd0383751755b00d31cddc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9191646a98f71ca193c82f1e7f7ea2e87ba7719248a7f03d5e1c95859b7bffca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e073312ca5b208c432c29986b2831669d1226838b349e5698e1c3a2323af323"
    sha256 cellar: :any_skip_relocation, sonoma:        "361b1bf2fa2baf04b334acbfd52c5a53562edcf3a3cb871dece3b6d00e950d63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7947d706ec7220af46965fd4210c327c9c4c30762957ec7364116ae9a9c68c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07c53d3799bdd37756e3d4aa91e57cd7e03f1ae551867f84070a44e66e9067e1"
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