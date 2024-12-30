class Nomino < Formula
  desc "Batch rename utility"
  homepage "https:github.comyaa110nomino"
  url "https:github.comyaa110nominoarchiverefstags1.4.0.tar.gz"
  sha256 "4b0e1debd76995b60ad020db97431ffcc01a64d4fc0040702ef0dea7ea368536"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comyaa110nomino.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5729d142d56baead1fa25ada956193ad29449ae618464e904380e30bc1cd776"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2ad5b47b0c6fb96487e9f7bdb46ae4ae931b38315b6b4ed9be142f445671fa8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41099632e58a15ac05cfa9d4d78e015e312c0385a3a52a971c88a2729737f02c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d103aa491a92f0929ddbb63a05d7d4ad554bd433d0130edefebfa8462eb6006"
    sha256 cellar: :any_skip_relocation, ventura:       "1c60c8e8ffdea1c93551caeda58aa544c9b41ae7f38096fa865aa405c91ef81c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b3c3a600f8ad5defe56c2361397053a45c2f0adc04d398cd7a593d36e7dc9ad"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (1..9).each do |n|
      (testpath"Homebrew-#{n}.txt").write n.to_s
    end

    system bin"nomino", "-e", ".*-(\\d+).*", "{}"

    (1..9).each do |n|
      assert_equal n.to_s, (testpath"#{n}.txt").read
      refute_predicate testpath"Homebrew-#{n}.txt", :exist?
    end
  end
end