class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.45.5.tar.gz"
  sha256 "945a08dad529803e5efc51483db6843319195f745563943c805f987193aa6784"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b8907c73144f0882c66482e50e465dea56da3b8e8faa14a7630a4a01db9e590"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8bcc95513c1507f6cd7a7aceefa3b3c09833a29d6fe9a3d933951f4c17789b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d5b44eb49ff1fc53ba8f7c228e10df684ada703e535a4855e197de66a5f7ed1"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb862aac8fdeccf50f3f1e7588abe3b887d84baa43d7823e458b8c0099c2feca"
    sha256 cellar: :any_skip_relocation, ventura:       "c92ac246ee74fd9291dcf6094f36ca6c239904a31796f66cd6591d0042432be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ab9f5bdce8a1ee09b825348597143edd71a3b0ccd80842e73abfbe3ab3c67e9"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  conflicts_with "nicotine-plus", because: "both install `nicotine` binaries"

  def install
    system "cargo", "install", "--features", "xattrs,acls", *std_cargo_args
    man1.install "httm.1"

    bin.install "scriptsounce.bash" => "ounce"
    bin.install "scriptsbowie.bash" => "bowie"
    bin.install "scriptsnicotine.bash" => "nicotine"
    bin.install "scriptsequine.bash" => "equine"
  end

  test do
    touch testpath"foo"
    assert_equal "ERROR: httm could not find any valid datasets on the system.",
      shell_output("#{bin}httm #{testpath}foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}httm --version").strip
  end
end