class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.12.6",
      revision: "ec191fef4b2b68b176612551cc88404bd7b21d42"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a28b3af7085b6a879117c4809c3f91f38423ad3231d9f759c44d2e9c2c29bd55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa8cae8e1abe5cbf96e67eb66220af75cd7415ba7ce8bcc0dc09494c2a63e12e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2dec7d21f61ea4cd873deb59e54513f0ad864cd9900d4ac693e439e328d2149"
    sha256 cellar: :any_skip_relocation, ventura:        "7c623a0a29baefe8bd6475ad4ba0f7e37b9e839da5077f5e82341e92a54e4ff6"
    sha256 cellar: :any_skip_relocation, monterey:       "76566988eb2e7e19acf03394fd65bf50eb61f8b94cd33639f996d7c0a093c0e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "b436b62b195602c55bc3846feec66ba3da337d5f327928598fb5c57ee79d4533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fce6711121b90e6255ac62d9cc282e3958121a28b735895dddc1e49c08540752"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    system "mage", "build"
    bin.install "cartridge"
    system bin/"cartridge", "gen", "completion"

    bash_completion.install "completion/bash/cartridge"
    zsh_completion.install "completion/zsh/_cartridge"
  end

  test do
    project_path = Pathname("test-project")
    project_path.rmtree if project_path.exist?
    system bin/"cartridge", "create", "--name", project_path
    assert_predicate project_path, :exist?
    assert_predicate project_path.join("init.lua"), :exist?
  end
end