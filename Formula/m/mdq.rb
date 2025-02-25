class Mdq < Formula
  desc "Like jq but for Markdown"
  homepage "https:github.comyshavitmdq"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comyshavitmdq.git", branch: "main"

  stable do
    url "https:github.comyshavitmdqarchiverefstagsv0.3.0.tar.gz"
    sha256 "0a62a73f762e6ffa38dc914c585916d50d093c282a4805d6abd3cf1896a14293"

    # version report patch
    patch do
      url "https:github.comyshavitmdqcommitd7b91546474dcd09e4ec384afcff0be726743522.patch?full_index=1"
      sha256 "7cdfdb00badb3a604589eeb53b620c5bca3da1c12000aec6f05b316ddfa3d920"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3d2f2855283fc7e7458e5ffb04007aa1bd0ba143205a8a252b5ced1e2816c92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7767d746c39f7b9b5878b23207fe170242177f4a1ed861f05b1b39245b90fead"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f23042f61a1fc3d2666900a43658e5ffb6c05f240cdc3ca877f9a92ef8a3a273"
    sha256 cellar: :any_skip_relocation, sonoma:        "b74ce6482986848b659f5c0f49e9a4a981007b36f1bc612bf8fb9789dc7fe5d8"
    sha256 cellar: :any_skip_relocation, ventura:       "15e25a33fe16d67a691f7a42d20c2fd8f3e91f3a3c46ff487b21cda4d86f72dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ac68513540bd5213c9bd71dcdb76860dcef968f76dbe7133add4a10c55d29e2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mdq --version")

    test_file = testpath"test.md"
    test_file.write <<~MARKDOWN
      # Sample Markdown

      ## Section 1

      - Item 1
      - Item 2

      ## Section 2

      - Item A
    MARKDOWN

    assert_equal <<~MARKDOWN, pipe_output("#{bin}mdq '# Section 2'", test_file.read)
      ## Section 2

      - Item A
    MARKDOWN
  end
end