class Teller < Formula
  desc "Secrets management tool for developers built in Go"
  homepage "https:github.comtelleropsteller"
  url "https:github.comtelleropstellerarchiverefstagsv2.0.4.tar.gz"
  sha256 "d340d160f00c0653d3160cf16aa41d22acb240556464d8803f234f1fe46efcef"
  license "Apache-2.0"
  head "https:github.comtelleropsteller.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1d8610ebf3ce901a06f407858327bad5fec92a1ac69e9e0668806ac132aa9a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bfc8893588f0ff31e521a97b8cb204f2745983f65f2a660ff01edade5ac3c25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d084f6be808c865cb3772521f52952dc8ea192ced27722e8c96c76389fe6ae7"
    sha256 cellar: :any_skip_relocation, sonoma:         "1dcf194fcd8a87d78e94a2b319b0baf1f89fbbad3c7975bcfb6ad2560158ae66"
    sha256 cellar: :any_skip_relocation, ventura:        "1c698a17ac17c8753fbff5569a0c9211c6b17537f08106bcea13c263ff0b6e57"
    sha256 cellar: :any_skip_relocation, monterey:       "b200f52d1ab8b2829c6d5ae189127da285cf0f6f83240273c8f9e4a59b5546d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90e92ebe7aaa823c55a0c757b0c16f4a8cc6581dd3c41b817270e3db31772f60"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "teller-cli")
  end

  test do
    (testpath"test.env").write <<~EOS
      foo=bar
    EOS

    (testpath".teller.yml").write <<~EOS
      project: brewtest
      providers:
        # this will fuse vars with the below .env file
        # use if you'd like to grab secrets from outside of the project tree
        dotenv:
          kind: dotenv
          maps:
          - id: one
            path: #{testpath}test.env
    EOS

    output = shell_output("#{bin}teller -c #{testpath}.teller.yml show 2>&1")
    assert_match "[dotenv (dotenv)]: foo = ba", output

    assert_match version.to_s, shell_output("#{bin}teller --version")
  end
end