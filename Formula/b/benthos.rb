class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://ghproxy.com/https://github.com/benthosdev/benthos/archive/refs/tags/v4.23.0.tar.gz"
  sha256 "f3c188e7b69b91744adb40eaa5854def67dc206a369a91e7d343b086d64418dd"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8869f4ba5960851f813753736466989627ad34a91222f07b9b94e8401e3e8141"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5482a649553dd7e93b52bccae5cb832268568312bc133238d1dd61aa54b1ad0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd6174bbcbf03be5871f0acf757214d7b69d3838392fd292a9fdbc565427b27e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5fb610f7874c0e6c099fc1a0dd903b70510678704adaadabc018df9bf5ef0120"
    sha256 cellar: :any_skip_relocation, ventura:        "d0604f3d6e0d5fd82d8f796ec251f5f5097bcca2d00ff480e9f0915ac79b941f"
    sha256 cellar: :any_skip_relocation, monterey:       "0e1cd7fb1718c67f5fe752011e15db7fdf55c8e14ef8382710717753c5cfa2df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "395efe68c365d1840cca8d64b2e77f10e4f1440dfeab999190eb1fc242463b2f"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "target/bin/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~EOS
      ---
      logger:
        level: ERROR
      input:
        file:
          paths: [ ./sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    EOS
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end