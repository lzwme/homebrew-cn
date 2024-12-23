class Oranda < Formula
  desc "Generate beautiful landing pages for your developer tools"
  homepage "https:opensource.axo.devoranda"
  url "https:github.comaxodotdevorandaarchiverefstagsv0.6.5.tar.gz"
  sha256 "456baf2b8e36ad6492d5d7a6d2b47b48be87c957db9068500dfd82897462d5bd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comaxodotdevoranda.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6355b74d463dc310169e38b54bd9faa4a957426aefcbb4457310208c4db98c81"
    sha256 cellar: :any,                 arm64_sonoma:  "d62d7a6ea26f3d47824cf8925c0b1ffe790f7bb22c989f4e2bdefaed2a044ea6"
    sha256 cellar: :any,                 arm64_ventura: "50de4218c89b00ec55016d6af55f0c1781888a7d516cf0b61d848f825a6651f8"
    sha256 cellar: :any,                 sonoma:        "c6add9bb2ff35ff1ea1b11fc3ab1b5a4bf9a0c8c0a143b034853ab6a84f3c884"
    sha256 cellar: :any,                 ventura:       "a061b0b2c9e3da6abddad58b5602d41c92170ade938567656692799448ea122e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38453321aae36b4c54631ebaa74ca576f791c4fd5e608bcb5e45088c96a3219c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"
  depends_on "tailwindcss"

  def install
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"
    ENV["ORANDA_USE_TAILWIND_BINARY"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "oranda #{version}", shell_output("#{bin}oranda --version")

    system bin"oranda", "build"
    assert_path_exists testpath"publicindex.html"

    begin
      output_log = testpath"output.log"
      pid = spawn bin"oranda", "serve", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "SUCCESS: Your project is available", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end