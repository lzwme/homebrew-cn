cask "xbench" do
  version "1.3"
  sha256 "285d860273b22054b807930ac496735e287d124f233da489e4104d2411690e55"

  url "http://xbench.com/Xbench_#{version}.dmg"
  name "Xbench"
  desc "Benchmarking software"
  homepage "http://xbench.com/"

  livecheck do
    url :homepage
    regex(/href=.*?Xbench[._-]v?(\d+(?:\.\d+)+)\.dmg/i)
  end

  app "XBench.app"
end