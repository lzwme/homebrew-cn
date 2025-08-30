class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  url "https://ghfast.top/https://github.com/foundry-rs/foundry/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "fbbef5f3af660db912647d85ce1d8a281d83c1dc0c2e7ddc304de4991acfec97"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4973091af84289a26bd0ce98f1bbf5938ee3a86f26fe4462e19dd189d730f49c"
    sha256 cellar: :any,                 arm64_sonoma:  "55c43dd36976273195bec687d0f43b7eb53ef0205b340ca17e7d5fb089f199d7"
    sha256 cellar: :any,                 arm64_ventura: "d756086190f3906843c3996dfee1412b212975f13d77e8909606767459c1ae72"
    sha256 cellar: :any,                 sonoma:        "5f4c2326a9939102259f89514b126e42beec78949ff58cc41e6f09a123c8bff5"
    sha256 cellar: :any,                 ventura:       "15bc63b8993be43ba828ae027c3e72f1ecca8b1d8e7109322a2d3fa6163c556e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df80439a5488da8ae28dd6e0dcbd8e50a3e407f4b8694c84975d1ba3209e02ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f58fbaa0ba036d7640a48df5e3573fca88f66914cf6f962a7c5aec938f6af9e5"
  end

  depends_on "help2man" => :build
  depends_on "rust" => :build

  on_macos do
    depends_on "libusb"
  end

  conflicts_with "chisel-tunnel", because: "both install `chisel` binaries"
  conflicts_with "jboss-forge", because: "both install `forge` binaries"

  def install
    ENV["TAG_NAME"] = tap.user

    %w[forge cast anvil chisel].each do |binary|
      system "cargo", "install", *std_cargo_args(path: "crates/#{binary}")

      # https://book.getfoundry.sh/config/shell-autocompletion
      generate_completions_from_executable(bin/binary.to_s, "completions") if binary != "chisel"

      system "help2man", bin/binary.to_s, "-o", "#{binary}.1", "-N"
      man1.install "#{binary}.1"
    end
  end

  test do
    project = testpath/"project"
    project.mkpath
    cd project do
      # forge init will create an initial git commit, which will fail if an email is not set.
      ENV["EMAIL"] = "example@example.com"
      system bin/"forge", "init"
      assert_path_exists project/"foundry.toml"
      assert_match "Suite result: ok.", shell_output("#{bin}/forge test")
    end

    assert_match "Decimal: 2\n", pipe_output("#{bin}/chisel", "1+1")

    anvil_port = free_port
    anvil = spawn bin/"anvil", "--port", anvil_port.to_s
    sleep 2
    assert_equal "31337", shell_output("#{bin}/cast cid -r 127.0.0.1:#{anvil_port}").chomp
  ensure
    if anvil
      Process.kill("TERM", anvil)
      Process.wait anvil
    end
  end
end