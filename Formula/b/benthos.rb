class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https:github.comredpanda-databenthos"
  url "https:github.comredpanda-databenthosarchiverefstagsv4.32.0.tar.gz"
  sha256 "5f07e91706d8e89d57018d73d0f6cd0a7ea54b4452b8eab2ff22c84f9fe93bd9"
  license "MIT"
  head "https:github.comredpanda-databenthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a993d392f4c0acf4113ecc83642f63b53b6c36243f275886c638ddc16a1b8f92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95be0a69c7348ac515496956d8ad7f5242f63d5eb9f964bb589ea1dcd9e2d2b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e710f858f527950a55c115270e1aca6424c73f8262ff6de7f20956575584877"
    sha256 cellar: :any_skip_relocation, sonoma:         "b66f34f19086562934898553eb45450653784c62fecffb957c4e197de0023094"
    sha256 cellar: :any_skip_relocation, ventura:        "3c0c8c511923fd711f92afa16dbeaf51839999fd8fd5f4be138d6c8e765bb470"
    sha256 cellar: :any_skip_relocation, monterey:       "a7bd08c0841af1b798fa336ede749e9265bbe7f0c331da7583deeef989cd6a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01d79a072bf062772ffd16439cce401a067d1a8094c4ee449864450d299265aa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdbenthos"
  end

  test do
    (testpath"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath"test_pipeline.yaml").write <<~EOS
      ---
      logger:
        level: ERROR
      input:
        file:
          paths: [ .sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    EOS
    output = shell_output("#{bin}benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end