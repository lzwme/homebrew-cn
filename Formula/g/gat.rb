class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://ghfast.top/https://github.com/koki-develop/gat/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "78cd49189f71487f0944e2cd895da70e0f2f7c036b8b20c4185209cf777a02fc"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c93de4fca6dece291a75d1699ed36f51bd416344869952170d2888ba776846f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c93de4fca6dece291a75d1699ed36f51bd416344869952170d2888ba776846f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c93de4fca6dece291a75d1699ed36f51bd416344869952170d2888ba776846f"
    sha256 cellar: :any_skip_relocation, sonoma:        "64cf0e76b7b3cedf4ac799b80888b8e67b2569213f338d2842e93aad29b9a6da"
    sha256 cellar: :any_skip_relocation, ventura:       "64cf0e76b7b3cedf4ac799b80888b8e67b2569213f338d2842e93aad29b9a6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8635039f0323742bb1b87f789eeef53d124dc7e638ef19ef6bad0c327e7f546b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end