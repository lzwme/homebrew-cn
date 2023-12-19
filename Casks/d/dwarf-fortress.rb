cask "dwarf-fortress" do
  version "0.47.05"
  sha256 "bc79a92adb96497d59546378e8c9ab2ef67ca22abfbd9763616de9c2e00e5f24"

  url "https:www.bay12games.comdwarvesdf_#{version.minor}_#{version.patch}_osx.tar.bz2"
  name "Dwarf Fortress"
  desc "Single-player fantasy game"
  homepage "https:www.bay12games.comdwarves"

  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}df_osxdf.wrapper.sh"
  deprecate! date: "2023-12-17", because: :discontinued

  binary shimscript, target: "dwarf-fortress"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{staged_path}df_osxdf' "$@"
    EOS
  end

  uninstall_preflight do
    if Dir.exist?("#{staged_path}df_osxdatasave")
      FileUtils.cp_r("#{staged_path}df_osxdatasave", "tmpdwarf-fortress-save")
    end
  end

  caveats do
    <<~EOS
      During uninstall, your save data will be copied to tmpdwarf-fortress-save
    EOS
  end
end