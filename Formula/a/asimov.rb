class Asimov < Formula
  desc "Automatically exclude development dependencies from Time Machine backups"
  homepage "https:github.comstevegrunwellasimov"
  url "https:github.comstevegrunwellasimovarchiverefstagsv0.3.0.tar.gz"
  sha256 "77a0ef09c86d9d6ff146547902c749c43bc054f331a12ecb9992db9673469fab"
  license "MIT"
  head "https:github.comstevegrunwellasimov.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "241f2672b244e0f6913abab7ab03d52d2f757d9bf1d384f79e880753e0ade64d"
  end

  def install
    bin.install buildpath"asimov"
  end

  # Asimov will run in the background on a daily basis
  service do
    run opt_bin"asimov"
    run_type :interval
    require_root true
    interval 86400 # 24 hours = 60 * 60 * 24
  end

  test do
    assert_match "Finding dependency directories with corresponding definition files…",
                 shell_output("#{bin}asimov")
  end
end