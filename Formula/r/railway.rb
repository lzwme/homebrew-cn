class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.12.1.tar.gz"
  sha256 "d12eaa0caba72eb1939fece953117fbe966fd5f7c86f70a4680d3b5115da9dfe"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dca37b849645cf31967daecfe49607e376093b7a36c186fb6fca1726f4baab5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a11ba874a4e102970d0b8edbc7c68ba5d88ba87c71b4ec5a5a51aeeace0e5be0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bae7491df662509f1f807e3bede53c46fffcc743c6c8bcca5e976d012b49f663"
    sha256 cellar: :any_skip_relocation, sonoma:        "817f8a6f52b3d2081fa0d45c65232348b89c72ec8a3bb5ae06a011c19409b7a9"
    sha256 cellar: :any,                 arm64_linux:   "fcfb7e0e2dc06c48799a7e176ae9a53f946d59d4d33703ba917fa39407f482c5"
    sha256 cellar: :any,                 x86_64_linux:  "8be7b7d20dc9948bb1d8fe5c0d436fdc57e1334e0b5b93560f9cc3afeaf93ca8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end