class Comtrya < Formula
  desc "Configuration and dotfile management tool"
  homepage "https:comtrya.dev"
  url "https:github.comcomtryacomtryaarchiverefstagsv0.9.0.tar.gz"
  sha256 "a5401004a92621057dab164db06ddf3ddb6a65f6cb2c7c4208a689decc404ad4"
  license "MIT"
  head "https:github.comcomtryacomtrya.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56bcd6407ac6f14a3ba79414c0651e52a2e262ce16b1148c70abc2ac1a121ead"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6686fa03d6d26a52beb6db4aa60d1dc51dfe34fda8e490d65c0ed96ee1adf883"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eaed784b320caf01dbf1130b956a34d5bf75d93c09555d9d5c3cdc799de13cad"
    sha256 cellar: :any_skip_relocation, sonoma:        "846c88f71d195eb80fe7a33024cd985bcd023455a6d2e52582e66b6a40613adc"
    sha256 cellar: :any_skip_relocation, ventura:       "ca956905d382263bc9ce55ddcda6f57612565322d33aa918621fe24e744f565e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "635873d62afde5a0e0e100273ec87da7d4d6bc3ee74f59c894bf7e8d346b3b77"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".app")
  end

  test do
    assert_match "comtrya #{version}", shell_output("#{bin}comtrya --version")

    resource "testmanifest" do
      url "https:raw.githubusercontent.comcomtryacomtryarefsheadsmainexamplesonlyvariantsmain.yaml"
      sha256 "0715e12cbbb95c8d6c36bb02ae4b49f9fa479e2f28356b8c1f3b5adfb000b93f"
    end

    resource("testmanifest").stage do
      system bin"comtrya", "-d", "main.yaml", "apply"
    end
  end
end