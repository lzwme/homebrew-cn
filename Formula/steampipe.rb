class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://ghproxy.com/https://github.com/turbot/steampipe/archive/refs/tags/v0.20.9.tar.gz"
  sha256 "5cae0aca5136666b669f4b85781bda3f27b9cb32de7a2f7cad14ff3cbc28adca"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6309665b85487fa0a928257ddde2ddfebe483c97b15335dd45f1f22d3b38440"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdc48705a89e8f548a71ce76d86e0dbbaa9dbc068308d849c64b0178e60d46ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74c08097f766d7431b9c90cadc403f4fb8919c00968f70dffbd02e07eba3d178"
    sha256 cellar: :any_skip_relocation, ventura:        "5e50dd52a3b75a6e75305e2d1cbb4f1d4c9f6bfe73c135f054237b0a6c998ab9"
    sha256 cellar: :any_skip_relocation, monterey:       "158f6a9e369caf61785e7dbe20bb09350142feca2fc961d35616435a3f81e719"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ab6be8f205e86c254a36a4c971c7a521c054014d729c28192bf49125b0569d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4125f6706c9f623f44cd0b39891e8a2c842aebbbfb7d0f91d48910c52a228740"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create installation directory", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end