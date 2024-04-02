class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.20.1.tar.gz"
  sha256 "642d96b0f21a16e1ac53ea011cdac1f3e1b722ce4bf95119bffd2357d40cb0a1"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e375f312791f0e52e9f8cdbc653c438c75c5fd5252d9616b3effe690188c398f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6ae5fbf5575f6fb643413656327d83d464924c53242e344214b9345cfe47f53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56d79f970cbf0fd248e997610bd1ffd8d652703284007d9089635c175c73c6c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "6744313248fa7a2d886d2ff717c99cf65fd857723466ff690ba749c72893b13b"
    sha256 cellar: :any_skip_relocation, ventura:        "21f36a62c5924faa50e1a68f734729d337ed850bb083228e56be0fd226083ad5"
    sha256 cellar: :any_skip_relocation, monterey:       "5cf9a828b7aec68772ec1993b0a51b9aac7febe468b0440cb8bc219fded34f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b0be6d2754ac57b7c507ff4d74a9e003abdea5a5b6a7adfaf41136644874e20"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}typos -", "teh", 2)
    assert_empty pipe_output("#{bin}typos -", "the")
  end
end