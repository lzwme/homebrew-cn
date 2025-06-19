class Oxker < Formula
  desc "Terminal User Interface (TUI) to view & control docker containers"
  homepage "https:github.commrjackwillsoxker"
  url "https:github.commrjackwillsoxkerarchiverefstagsv0.10.4.tar.gz"
  sha256 "97c124e29b8ee3e92162c23f34aca78f585fed1a49727d865f06d5c02348805c"
  license "MIT"
  head "https:github.commrjackwillsoxker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dae0b4e183f4132e9c14f95d3c91c4aad26ea07b5f7a9ef6dbb296a15f77fdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7859d51bfc65b2275c1aaa8a79902d428be25985930b16df741e96572b6f6d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "165457fa8c22d05c68129b41e28cad8f73160185dd970ce3e48fb8579f607f24"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8c93adb35a8b3e01484fd54f007cfd333986f6e591ef4dfc3314eb34c9dc620"
    sha256 cellar: :any_skip_relocation, ventura:       "1e98f706e77035e0d03f8b8ed694e6e3c05f884daed87eda61a811d6c1ce77b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f397f49ea6d8e6792f16b14b0c3630befb4a72543d3ac16afd08b91a4fd47dfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4826164f49977f1d12b389457ce74146857d751a8e149b572ebcb38658580c7f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin"oxker --version")

    assert_match "a value is required for '--host <HOST>' but none was supplied",
      shell_output(bin"oxker --host 2>&1", 2)
  end
end